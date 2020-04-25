//
//  DrawerView.swift
//  DosKaz
//
//  Created by Yesbol Kulanbekov on 3/7/20.
//  Copyright © 2020 zed. All rights reserved.
//

import UIKit

/// A container view that slides up from the bottom over a parent view. Can be
/// minimized, cover the bottom half of the view or display fullscreen
/// (parent view is hidden).
open class DrawerView: UIView {
	
	// MARK: - Public
	
	/// Designated initializer.
	
	public init() {
		
		currentPosition = peekingPosition
		
		super.init(frame: .zero)
		
		// Set drawer position content height closures.
		openFullPosition.contentHeightClosure = { [unowned self] in
			var height: CGFloat {
				// The view height is adequate when `availableHeight` has not been set. However,
				// `availableHeight` should be used when set, because the view height sometimes includes the
				// status bar.
				guard let availableHeight = self.availableHeight else { return self.bounds.size.height }
				return availableHeight
			}
			return height - self.safeAreaInsetsOrZero.top -	self.safeAreaInsetsOrZero.bottom
		}
		openHalfPosition.contentHeightClosure = { [unowned self] in
			self.openFullPosition.contentHeight / 2
		}
		peekingPosition.contentHeightClosure = { 60 }
		
		let panGestureRecognizer = UIPanGestureRecognizer(target: self,
																											action: #selector(handlePanGesture(_:)))
		addGestureRecognizer(panGestureRecognizer)
		
		configureView()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	/// Position of the drawer when it is fully open.
	let openFullPosition = DrawerPosition(canShowKeyboard: true)
	
	/// Position of the drawer when it is halfway open.
	let openHalfPosition = DrawerPosition(canShowKeyboard: false)
	
	/// Position of the drawer when it is when only the tab bar is showing.
	let peekingPosition = DrawerPosition(canShowKeyboard: false) { 0 }
	
	/// Sets the available height and updates content view height. This needs to be set when the view
	/// frame is updated.
	func setAvailableHeight(_ height: CGFloat) {
		// Only update content view height if the view height is greater than 0 and is not the same as
		// it was the last time it was set.
		
		let hasChanged = availableHeight == nil || height > availableHeight! || height < availableHeight!
		guard height > 0 &&  hasChanged else { return }
		
		availableHeight = height
		updateContentViewHeight()
	}
	
	/// Pans to `position`, and captures the new position into `currentPosition`.
	///
	/// - Parameters:
	///   - position: The position to animate to.
	///   - animated: Whether or not to animate.
	///   - completion: Called when the pan completes.
	func panToPosition(_ position: DrawerPosition,
										 animated: Bool = true,
										 completion: (() -> Void)? = nil) {
		// Calculate animation duration based on the remaining distance.
		let distanceRemaining = position.panDistance - currentPanDistance
		let remainingRatio = abs(distanceRemaining / maximumPanDistance)
		let duration = animated ?
			max(fullToPeekingAnimationDuration * Double(remainingRatio), minimumAnimationDuration) : 0
		//delegate?.drawerView(self, willChangePosition: position)
		//let previousPosition = currentPosition
		currentPosition = position
		
		func animatePan(completion panCompletion: (() -> Void)? = nil) {
			UIView.animate(
				withDuration: duration,
				delay: 0,
				options: [.curveEaseOut],
				animations: {
					self.currentPanDistance = position.panDistance
					self.layoutIfNeeded()
			},
				completion: { (_) in
					//self.delegate?.drawerView(self, didChangePosition: self.currentPosition)
					panCompletion?()
					completion?()
			})
			
		}
		
		animatePan()
	}
	
	// MARK: - Methods called by the system, i.e. messages from the system
	
	open override func layoutSubviews() {
		super.layoutSubviews()
		
	}
	
	override open func safeAreaInsetsDidChange() {
		setNeedsLayout()
		updateContentViewHeight()
		
		// If the safe area insets change, the drawer positions change. Pan to the correct distance for
		// the current drawer position.
		panToCurrentPosition(animated: false)
	}
	
	override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		// Only count the panning view as part of the drawer view.
		return panningView.point(inside: convert(point, to: panningView), with: event)
	}
	
	// MARK: - Private
	
	/// Adds a view as a subview of `contentView` and sets it to be full size.
	func displayViewInContentView(_ view: UIView) {
		view.translatesAutoresizingMaskIntoConstraints = false
		stackView.addArrangedSubview(view)
	}
	
	var topConstraint: NSLayoutConstraint!
		
	private func configureView() {
		
		addSubview(panningView)
		
		panningView.addConstraintsProgrammatically
			.pinEdgeToSupers(.leading)
			.pinEdgeToSupers(.trailing)
			.pinEdgeToSupers(.bottom )
		
		topConstraint = panningView.addConstraintsProgrammatically
			.pinEdgeToSupers(.top)
			.constraint
		
		// Content view.
		contentView.isScrollEnabled = false
		contentView.backgroundColor = .systemGreen
		panningView.addSubview(contentView)
		
		contentView.addConstraintsProgrammatically
			.pinToSuper()
		
		contentView.addSubview(stackView)
		stackView.addConstraintsProgrammatically
			.pinToSuper()
			.equate(my: .width, and: .width, of: contentView)
		
	}
	
	// The total available height the drawer view can fill, set externally in
	// `updateContentViewHeight()`. Used to determine the full height drawer position, as well as
	// content view height.
	private var availableHeight: CGFloat?
	
	private func updateContentViewHeight() {
	
	}
	
	private let minimumAnimationDuration = 0.1
	
	// The duration for the animation if the pan is from full to peeking.
	private let fullToPeekingAnimationDuration = 0.5
	
	/// The panning view.
	private let panningView = UIView()
	
	// The content view for a view controller's view to be displayed.
	private let contentView = UIScrollView()
	
	private let stackView: UIStackView = {
		let stack = UIStackView()
		stack.axis = .vertical
		return stack
	}()
	
	/// Whether or not the drawer can be open half. This should be set to false when the device is in
	/// landscape.
	private var canOpenHalf = true
	
	/// Whether or not the drawer can be open to a custom position. This should be set to false when
	/// the device is in landscape.
	private var canOpenToCustomPosition = true
	
	/// A custom drawer position for the drawer. Valid only if its pan distance falls between peeking
	/// and open full.
	fileprivate(set) var customPosition: DrawerPosition?
	
	// All drawer positions.
	private var drawerPositions: [DrawerPosition] {
		var positions = [peekingPosition, openFullPosition]
		if canOpenHalf {
			positions.append(openHalfPosition)
		}
		if canOpenToCustomPosition, let customPosition = customPosition {
			positions.append(customPosition)
		}
		positions.sort { $0.panDistance > $1.panDistance }
		return positions
	}
	
	// The percentage of the distance between pan positions that must be traveled to move to the next
	// pan position.
	private let panPercentage: CGFloat = 0.15
	
	// The distance between peeking and open full positions.
	private var maximumPanDistance: CGFloat {
		return peekingPosition.panDistance - openFullPosition.panDistance
	}
	
	// MARK: - Important Panning controls
	
	private var currentPanDistance: CGFloat = 0 {
		didSet {
			// Update the panning view's y origin for the pan distance.
			topConstraint.constant = panningViewOriginY
		}
	}

	private var panningViewOriginY: CGFloat {
		return bounds.maxY - safeAreaInsetsOrZero.bottom +
		currentPanDistance
	}
	
	/// The current drawer position.
	private var currentPosition: DrawerPosition
	
	/// Pans the distance associated with the current position. Needed because the pan distance
	/// changes per position when the size of the view changes.
	///
	/// - Parameter animated: Whether or not to animate.
	private func panToCurrentPosition(animated: Bool) {
		panToPosition(currentPosition, animated: animated)
	}
	
	/// Completes the pan by snapping to the proper drawer position.
	///
	/// - Parameter velocity: The ending velocity of the pan.
	private func completePan(withVelocity velocity: CGFloat) {
		let isVelocityHigh = abs(velocity) > 500
		
		// Is the drawer's pan distance below the pan distance of the previous position? If not, it is
		// above or at the same position.
		let isDrawerBelowPreviousPosition = currentPanDistance > currentPosition.panDistance
		
		// Was the ending velocity in the opposite direction than the current pan distance of the
		// drawer? If so, return to the previous position if the velocity was high enough.
		let isVelocityOpposingPanDirection = isDrawerBelowPreviousPosition && velocity < 0 ||
			!isDrawerBelowPreviousPosition && velocity > 0
		if isVelocityOpposingPanDirection && isVelocityHigh {
			panToCurrentPosition(animated: true)
		} else {
			let position = nextPosition(below: isDrawerBelowPreviousPosition,
																	withPanDistance: currentPanDistance,
																	skipDistanceCheck: isVelocityHigh)
			panToPosition(position)
		}
	}
	
	/// Pans the drawer by a distance.
	///
	/// - Parameter distance: The distance to pan the drawer.
	private func pan(distance: CGFloat) {
		// Update the panning view's pan distance to a value clamped between open full and peeking.
		let range = ((openFullPosition.panDistance-1000)...(peekingPosition.panDistance + 1000))
		let clampedPanDistance = range.clamp(panDistance(withAdditionalPan: distance))
		currentPanDistance = clampedPanDistance
	}
	
	// The pan distance of the panning view added to an additional pan distance.
	private func panDistance(withAdditionalPan pan: CGFloat) -> CGFloat {
		return currentPosition.panDistance + pan
	}
	
	/// The next position for the drawer based on pan position and whether to return the next position
	/// below or above.
	///
	/// - Parameters:
	///   - below: Whether the next position should be below the current position. Otherwise above.
	///   - panDistance: The pan distance of the panning view.
	///   - isSkippingDistanceCheck: If true, the next position will be returned regardless of how far
	///                              away it is.
	/// - Returns: The position.
	private func nextPosition(below: Bool,
														withPanDistance panDistance: CGFloat,
														skipDistanceCheck isSkippingDistanceCheck: Bool) -> DrawerPosition {
		// If the position is above open full, return open full.
		if panDistance < openFullPosition.panDistance {
			return openFullPosition
		}
		
		// If the position is below peeking, return peeking.
		if panDistance > peekingPosition.panDistance {
			return peekingPosition
		}
		
		// If moving to the next position below the previous one, reverse the order of the positions.
		let orderedPositions = below ? drawerPositions.reversed() : drawerPositions
		
		// The index of the next position.
		var nextPositionIndex: Int {
			// Current position index.
			guard let indexOfCurrentPosition =
				orderedPositions.firstIndex(where: { $0 == currentPosition }) else { return 0 }
			
			// Next position index is +1 from the current index.
			let nextPositionIndex = indexOfCurrentPosition + 1
			
			// The next index can't be beyond the last index.
			guard nextPositionIndex < orderedPositions.endIndex else {
				return orderedPositions.endIndex - 1
			}
			
			return nextPositionIndex
		}
		
		// Check positions that are beyond the pan distance.
		let positionsToCheck = orderedPositions[nextPositionIndex...orderedPositions.endIndex - 1]
		
		// Check each position. If it is far enough away from the current position, return it. If none
		// are, return the previous position.
		var position = currentPosition
		for nextPosition in positionsToCheck {
			if isSkippingDistanceCheck {
				if below && nextPosition.panDistance > currentPanDistance ||
					!below && nextPosition.panDistance < currentPanDistance {
					// If overriding the distance check, use this position if it is beyond the pan distance.
					return nextPosition
				} else {
					continue
				}
			}
			
			if below {
				let distanceBetween = nextPosition.panDistance - position.panDistance
				let farEnoughForNextPosition = position.panDistance + distanceBetween * panPercentage
				if panDistance > farEnoughForNextPosition {
					position = nextPosition
					continue
				}
			} else {
				let distanceBetween = position.panDistance - nextPosition.panDistance
				let farEnoughForNextPosition = position.panDistance - distanceBetween * panPercentage
				if panDistance < farEnoughForNextPosition {
					position = nextPosition
					continue
				}
			}
			break
		}
		return position
	}
	
	// MARK: - Gesture recognizer
	
	@objc private func handlePanGesture(_ panGestureRecognizer: UIPanGestureRecognizer) {
		
		let gestureDistance = panGestureRecognizer.translation(in: self).y
		
		switch panGestureRecognizer.state {
		case .changed:
			pan(distance: gestureDistance)
		case .ended:
			completePan(withVelocity: panGestureRecognizer.velocity(in: self).y)
		default:
			break
		}
		
	}
	
}
